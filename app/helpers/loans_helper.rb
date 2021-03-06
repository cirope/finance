module LoansHelper
  def customer_label
    raw customer_text_label << ' ' << add_customer_link
  end

  def link_to_new_loan_schedule(loan)
    link_to(
      content_tag(:span, nil, class: 'glyphicon glyphicon-time'),
      new_loan_schedule_path(loan), data: { remote: true }
    )
  end

  def loan_progress_info(loan)
    progress = loan.progress

    progress_class = case progress
      when 0..50   then 'progress-bar-danger'
      when 51..74  then 'progress-bar-warning'
      when 75..89  then 'progress-bar-info'
      when 90..100 then 'progress-bar-success'
    end

    render(
      partial: 'loans/progress',
      locals: { loan: loan, progress: progress, progress_class: progress_class },
      formats: [:html]
    )
  end

  def loan_delayed_at_info(loan)
    t(
      'datetime.distance_in_words.x_days',
      count: (Date.today - loan.next_payment_expire_at).to_i
    )
  end

  def show_payments_count(loan)
    "#{loan.paid_payments_count}/#{loan.payments_count}"
  end

  def show_loan_status(loan)
    status = case loan.status
      when 'current' then 'label-success'
      when 'canceled', 'history' then 'label-info'
      when 'expired' then 'label-warning'
      when 'judicial' then 'label-danger'
    end

    content_tag(:span, t("loans.status.#{loan.status}"), class: "label #{status}")
  end

  def show_filter_column
    case params[:filter]
      when 'expired'
        content_tag(:th, Loan.human_attribute_name('delayed_at'))
      when 'close_to_expire'
        content_tag(:th, Loan.human_attribute_name('progress'))
      when 'not_renewed'
        content_tag(:th, Loan.human_attribute_name('canceled_at'))
      else
        content_tag(:th, Loan.human_attribute_name('status'))
    end
  end

  def show_filter_row(loan)
    case params[:filter]
      when 'expired'
        content_tag(:td, loan_delayed_at_info(loan))
      when 'close_to_expire'
        content_tag(:td, loan_progress_info(loan))
      when 'not_renewed'
        content_tag(:td, l(loan.canceled_at))
      else
        content_tag(:td, show_loan_status(loan))
    end
  end

  def show_customer_status loan
    status_class = @new_loans.include?(loan) ? 'text-primary' : 'text-danger'

    link_to loan.customer, loan_path(loan), data: { remote: true },
      class: status_class
  end

  private

    def customer_text_label
      Loan.human_attribute_name 'customer'
    end

    def add_customer_link
      link_to new_customer_path, title: t('loans.new.customer'), data: { remote: true } do
        content_tag :span, nil, class: 'glyphicon glyphicon-plus-sign'
      end
    end
end
