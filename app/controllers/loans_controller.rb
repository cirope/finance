class LoansController < ApplicationController
  include Loans::ActionFilters

  respond_to :html, :json, :js

  before_action :authorize
  before_action :set_customer, only: [:new, :create, :show]
  before_action :set_loan, only: [:show]
  before_action :set_rate_set, only: [:create]
  before_action :set_title

  # GET /loans
  def index
    @loans = @loans.page(params[:page])
  end

  # GET /loans/1
  def show
  end

  # GET /loans/new
  def new
    @loan = Loan.new(customer: @customer)
  end

  # POST /loans
  def create
    @loan = current_user.loans.new(
      loan_params.merge(customer: @customer)
    )

    respond_to do |format|
      if @loan.save
        format.js { redirect_via_turbolinks_to [@customer, @loan] }
      else
        format.js { render 'new' }
      end
    end
  end

  private

    def set_loan
      @loan = Loan.find(params[:id])
    end

    def set_customer
      @customer = Customer.find_by(id: params[:customer_id])
    end

    def set_rate_set
      @rate_set = RateSet.find_by(id: loan_params[:rate_set_id])
    end

    def loan_params
      params.require(:loan).permit :amount, :rate_id, :rate_set_id, :lock_version
    end
end
