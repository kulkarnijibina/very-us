ActiveAdmin.register MasterBucketConfig do
  permit_params match_count_for_day: MasterBucketConfig::KEYS

  collection_action :add_new_bucket, method: :post do
    bucket= Bucket.new
    if bucket.save
      unless params[:id].present?
        redirect_to new_admin_master_bucket_config_path
      else
        redirect_to edit_admin_master_bucket_config_path(params[:id])
      end
    else
      flash[:error] = bucket.errors
      redirect_to edit_admin_master_bucket_config_path(params[:id])
    end
  end

  collection_action :delete_bucket, method: :post do
    @buckets = Bucket.all
    bucket = @buckets.find_by(id: params[:bucket_id])
    if (Bucket::KEYS.map {|key| (bucket.percentage_for_day["#{key}"]).to_s == "0" }).all?
      if bucket.destroy
        flash[:notice] = "Bucket was successfully destroyed."
        unless params[:id].present?
          redirect_to new_admin_master_bucket_config_path
        else
          redirect_to edit_admin_master_bucket_config_path(params[:id])
        end
      else
        render :edit
      end
    else
      flash[:error] = "You need to make percentage of all days to zero, to delete Bucket- #{bucket.id}."
      unless params[:id].present?
        redirect_to new_admin_master_bucket_config_path
      else
        redirect_to edit_admin_master_bucket_config_path(params[:id])
      end
    end
  end

  controller do
    before_action :buckets, only: [:edit,:new,:show]

    before_action :assign_buckets, only: [:update, :create]

    def buckets
      @buckets = Bucket.all
      @error = ""
      @error_key = ""
    end

    def assign_buckets
      @buckets = Bucket.all
      @error = ""
      @error_key = ""
      buckets_params = params[:bucket]
      @buckets= @buckets.map do |bucket|
        bucket.assign_attributes(percentage_for_day: buckets_params[bucket.id.to_s]['percentage_for_day'], threshold_percentage: buckets_params[bucket.id.to_s]['threshold_percentage'])
        bucket
      end
    end

    def validate_bucket_params
      Bucket::KEYS.each do |key|
        if params[:bucket].values.pluck(:percentage_for_day).pluck(key).map(&:to_i).sum != 100
          return [false, "Total percentage must be 100 for #{key}", key]
        end
      end
      [true, nil, nil]
    end

    def handle_response(template_name, object)
      success, error_msg, key = validate_bucket_params
      if success
        @buckets.each(&:save)
        true
      else
        @error = error_msg
        @error_key = key
        flash[:error] = error_msg
        false
      end
    end

    def update
      super do |success, failure|
        success.html do
          if handle_response(:new, self)
            super
          else
            flash[:notice] = nil
            render :edit
          end
        end
      end
    end

    def create
      super do |success, failure|
        success.html do
          if handle_response(:new, self)
            super
          else
            flash[:notice] = nil
            render :new
          end
        end
      end
    end

  end

  scope :active, default: true
  scope :inactive

  config.filters = false

  index do
    selectable_column
    id_column
    column :match_count_for_day do |object|
      MasterBucketConfig::KEYS.map do |key|
        content_tag :p, "#{key}: #{object.match_count_for_day[key]}"
      end.join.html_safe
    end
    column :created_at
    column :updated_at
    actions
  end

  show do
    attributes_table do
      row :match_count_for_day do |object|
        MasterBucketConfig::KEYS.map do |key|
          content_tag :p, "#{key}: #{object.match_count_for_day[key]}"
        end.join.html_safe
      end
      row :buckets do
        panel "Buckets" do
          render 'buckets_table', { keys: Bucket::KEYS, buckets: buckets.order(id: :asc) }
        end
      end
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.semantic_errors
    f.inputs do
      f.inputs :name => "Match Count For Day", :for => :match_count_for_day do |g|
        MasterBucketConfig::KEYS.each do |key|
          g.input key, as: :number, :input_html => { :value => "#{f.object.match_count_for_day[key]}" }
        end
      end

      f.inputs :status

      panel "Buckets", class: "panel buckets_panel" do
        @keys = ["bucket", "threshold_percentage"] + Bucket::KEYS + ["delete_bucket"]
        @keys.each do |key|
          f.inputs :name => key.to_s.humanize, class: "buckets_panel_form inline_display #{key}", :for => key do |g|
            buckets.order(id: :asc).each do |bucket|
              case key
              when 'threshold_percentage'
                g.input "B-#{bucket.id}".to_s, as: :number, label: false, :input_html => { name: "bucket[#{bucket.id}][threshold_percentage]", :value => "#{bucket.threshold_percentage}"}
              when 'bucket'
                g.template.concat "<p class= 'bucket_label' >Bucket-#{bucket.id}</p><br>".html_safe
              when 'delete_bucket'
                g.template.concat "<a class= 'delete_add_bucket' rel='nofollow' data-method='post' href=#{delete_bucket_admin_master_bucket_configs_path(id: object.id, bucket_id: bucket.id)}>Delete Bucket</a><br>".html_safe
              else
                if error_key == key
                  g.input "bucket-#{bucket.id}".to_s, as: :number, label: false,:input_html => { name: "bucket[#{bucket.id}][percentage_for_day][#{key}]", :value => "#{bucket.percentage_for_day[key]}", label: false, :class => "percentage_for_day error" }
                else
                  g.input "B-#{bucket.id}".to_s, as: :number, label: false,:input_html => { name: "bucket[#{bucket.id}][percentage_for_day][#{key}]", :value => "#{bucket.percentage_for_day[key]}", label: false, :class => "percentage_for_day" }
                end
              end
            end
          end
        end
        div do
          link_to("Add New Bucket", add_new_bucket_admin_master_bucket_configs_path(id: object.id), :method => :post, class: "delete_add_bucket")
        end
      end
    end
    f.actions
  end
end
