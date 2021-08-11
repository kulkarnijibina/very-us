ActiveAdmin.register_page "Promotion" do
  breadcrumb do
    ['admin', 'promotion']
  end
  page_action :add_title, method: :post do
    if params[:promotion][:title].present? && params[:promotion][:notify_message].present? && params[:promotion][:schedule_time].present?
      wait_until = params[:promotion][:schedule_time].in_time_zone
      SendPromotionJob.set(wait_until: wait_until).perform_later(params[:promotion][:title], params[:promotion][:notify_message])
      redirect_to admin_promotion_path, notice: "Promotion Sent to all active users!"
    else
      redirect_to admin_promotion_path, alert: "Title, Notification Message and Schedule Time cant be blank!!!"
    end
  end

  content do
    active_admin_form_for 'promotion', :url => admin_promotion_add_title_path do |f|
      f.inputs :name => 'Promotion', :class => 'inputs' do
        f.input :title, input_html: { required: true }
        f.input :notify_message, input_html: { required: true }
        li do
          f.label "Schedule Time"
          f.datetime_field "schedule_time", min: Time.current.strftime("%Y-%m-%d"), value: Time.current.strftime("%Y-%m-%dT%H:%M")
        end

        f.submit 'Send Promotion'
      end
    end
  end
end
