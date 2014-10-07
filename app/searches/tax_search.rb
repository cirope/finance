class TaxSearch < Searchlight::Search

  search_on Tax.unscoped.includes(:customer).report_order

  searches :start_date, :end_date, :tax_setting_id

  def search_tax_setting_id
    search.where(tax_setting_id: tax_setting_id)
  end

  def search_start_date
    search.where(
      "#{Tax.table_name}.expire_at >= :start_date", start_date: start_date
    )
  end

  def search_end_date
    search.where(
      "#{Tax.table_name}.expire_at <= :end_date", end_date: end_date
    )
  end
end