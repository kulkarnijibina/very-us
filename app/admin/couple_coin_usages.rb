ActiveAdmin.register_page 'Couple Coin Usage' do
  
  breadcrumb do
    ['admin', 'Couple Coin Usage']
  end

  content do
    active_admin_form_for 'couple_coin_usage', url: admin_couple_coin_usage_import_csv_path(format: :csv) do |f|
      f.inputs :name => 'Couple Coin Usage', :class => 'inputs' do
        li do
          f.label "Start Time"
          f.date_field "start_time", value: 1.month.ago.in_time_zone.strftime("%Y-%m-%d"), style: "width: 250px"
        end
        li do
          f.label "End Time"
          f.date_field "end_time", value: Time.current.strftime("%Y-%m-%d"), style: "width: 250px"
        end
        li do
          f.submit 'Generate CSV', data: { disable_with: false }
        end 

      end
    end
  end

  page_action :import_csv, method: :post do
    if params[:couple_coin_usage][:start_time] > params[:couple_coin_usage][:end_time]
      flash[:alert] = "End time must be greater than Start time!"
      redirect_to admin_couple_coin_usage_path
    elsif params[:couple_coin_usage][:start_time] <= params[:couple_coin_usage][:end_time]
      csv = CoupleCoinUsage.call(params[:couple_coin_usage][:start_time], params[:couple_coin_usage][:end_time])
      respond_to do |format|
        format.html
        format.csv { send_data  csv, filename: "couple_coin_usage_report.csv" }
      end
    end
  end
 
end
