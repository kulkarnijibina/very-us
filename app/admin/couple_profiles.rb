ActiveAdmin.register CoupleProfile do  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters

  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :anniversary, :orientation, :have_children, :have_pets, :do_for_fun, :goals, :values_needed, :meetup_dates, :chat_availability, :primary_user_id, :secondary_user_id, :partner_number
  #
  # or
  #
  # permit_params do
  #   permitted = [:anniversary, :orientation, :have_children, :have_pets, :do_for_fun, :goals, :values_needed, :meetup_dates, :chat_availability, :primary_user_id, :secondary_user_id, :partner_number]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  action_item :new_couple_profile, :only => :index do
    link_to "New Couple Profile", new_admin_couple_profile_path, class: "new_couple_profile"
  end

  controller do
    def create
      @couple_profile = CoupleProfile.new(couple_profile_params)
      if @couple_profile.save
        AddEarnCoinsService.call(:onboarding, @couple_profile)
        AddEarnCoinsService.call(:partner_app_download, @couple_profile)
        redirect_to admin_couple_profile_path(@couple_profile), notice: "Successfully created Couple Profile."
      else
        render :new
      end
    end

    def update
      @couple_profile = CoupleProfile.find_by_id(params[:id])
      if @couple_profile.update(couple_profile_params)
        redirect_to admin_couple_profiles_path, notice: "Successfully updated Couple Profile."
      else
        render :edit
      end
    end

    private
    def couple_profile_params
      params.require(:couple_profile).permit(
          :verified_profile,
          primary_user_attributes: [ :first_name, :last_name, :gender, :country_code, :date_of_birth, :contact, :orientation],
          secondary_user_attributes: [ :first_name, :last_name, :gender, :country_code, :date_of_birth, :contact, :orientation],
          personality_traits: [],
          activities: [],
          images_attributes: [:id, :image, :is_profile_pic, :_destroy],
          location_attributes: [:id, :latitude, :longitude]
        )
    end
  end

  batch_action :send_coins , form: {
      coins: :number,
      description: :text
    } do |ids, inputs|
      # inputs is a hash of all the form fields you requested
    couple_profiles = CoupleProfile.where(id: ids)
    response = SendCoinsToProfileService.call(couple_profiles, inputs['coins'], inputs['description'], 'reward_coins')
    if response[:success]
      redirect_to collection_path, notice: "Sucessfully disperse coins to couple_profiles."
    else
      redirect_to collection_path, alert: response[:errors]
    end
  end

  member_action :clear_partner_number, method: :post do
    couple_profile = CoupleProfile.find(params[:id])
    if couple_profile.partner_number.present?
      if couple_profile.update(partner_number: "", partner_country_code: "")
        redirect_to admin_couple_profile_path(couple_profile), notice: "Partner number cleared Successfully!"
      else
        redirect_to admin_couple_profile_path(couple_profile), alert: "Partner number not cleared!"
      end
    else
      redirect_to admin_couple_profile_path(couple_profile), alert: "Couple Profile doesn't have partner number!"
    end
  end


  actions :all, :except => [:destroy]
  config.filters = false

  index do
    selectable_column
    actions
    id_column
    column :meetup_dates
    column :chat_availability
    column :primary_user
    column :secondary_user
    column :partner_number
    column :personality_traits
    column :activities
    column :irrelevant_match_counter
    column :profile_completed
    column :verified_profile
    column :secondary_user_details
    column :free_save_for_later_count
    column :place
    column :status
    column :created_at
    column :updated_at
  end

  show do
    attributes_table do
      row :anniversary
      row :have_children
      row :have_pets
      row :do_for_fun
      row :goals
      row :values_needed
      row :chat_availability
      row :primary_user
      row :secondary_user
      row :partner_number
      row :created_at
      row :updated_at
      row :personality_traits
      row :activities
      row :profile_completed
      row :verified_profile
      row :secondary_user_details
      row :spotlight_on_time
      row :incognito_time
      row :free_save_for_later_count
      row :partner_country_code
      row :place
      row :status
      row :karma_score
      row :location do |object|
        if object.location
          [object.location.latitude, object.location.longitude]
        end
      end

      row :date do |object|
        div do
          form_tag [:admin, object], :url => admin_couple_profile_path(object), method: :get, builder: ActiveAdmin::FormBuilder do |f|
            date_field_tag(:date, params[:date] || Date.current, id: "match_date")
          end
        end
      end

      row :matches_for_the_day do |object|
        table_for object.get_matches_for_the_day(params[:date]) do
          column :matched_couple do |match|
            match.target_couple
          end
          column :match_percentage do |match|
            match.percentage
          end
          column :bucket do |match|
            match.bucket_id
          end
          column :threshold_percentage do |match|
            match.bucket.threshold_percentage
          end
          column :distance do |match|
            match.source_couple.get_distance_with(match.target_couple)
          end
        end
      end

      row :clear_partner_number do |object|
        link_to('clear partner number', clear_partner_number_admin_couple_profile_path(object), method: :post)
      end

      row :meetup_details do |object|
        table_for object.all_meetups.accepted do
         column :meetup_couple do |meetup|
            meetup.other_couple(object)
          end
          column :status do |meetup|
            meetup.status
          end
          column :date_time do |meetup|
            meetup.date_time
          end
          column :location do |meetup|
            meetup.location
          end
          column :description do |meetup|
            meetup.description
          end
        end
      end

      row :received_meetup_feedbacks do |object|
        table_for object.received_meetup_feedbacks do
          column :meetup_id do |meetup_feedback|
            meetup_feedback.meetup_id
          end
          column :target_couple_id do |meetup_feedback|
            meetup_feedback.source_couple
          end
          column :is_couple_same do |meetup_feedback|
            meetup_feedback.is_couple_same
          end
          column :meet_again do |meetup_feedback|
            meetup_feedback.meet_again
          end
          column :couple_behaviour do |meetup_feedback|
            meetup_feedback.couple_behaviour
          end
          column :couple_badge do |meetup_feedback|
            meetup_feedback.couple_badge
          end
        end
      end

      row :irrelevant_matches do |object|
        table_for object.relationships.is_irrelevant_match do
          column :target_couple
          column :reason
          column :created_at
        end
      end

      row :reported_by do |object|
        table_for object.target_relationships.is_reported do
          column :source_couple
          column :reason
          column :created_at
        end
      end
    end
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    panel "Primary User", class: "panel primary_user_panel" do
      f.inputs :primary_user, for: [:primary_user, f.object.primary_user || User.new] do |t|
        t.input :country_code
        t.input :contact
        t.input :first_name
        t.input :last_name
        t.input :gender, as: :select, collection: ["Male", "Female"]
        t.input :orientation, as: :select, collection: User::ORIENTATION
        t.input :date_of_birth, as: :date_picker, input_html: { max: 18.years.ago.strftime("%Y-%m-%d"), style: "width: 250px" }
      end
    end
    panel "Secondary User", class: "panel secondary_user_panel" do
      f.inputs :secondary_user, for: [:secondary_user, f.object.secondary_user || User.new] do |t|
        t.input :country_code
        t.input :contact
        t.input :first_name
        t.input :last_name
        t.input :gender, as: :select, collection: ["Male", "Female"]
        t.input :orientation, as: :select, collection: User::ORIENTATION
        t.input :date_of_birth, as: :date_picker, input_html: { max: 18.years.ago.strftime("%Y-%m-%d"), style: "width: 250px" }
      end
    end
    f.inputs do
      f.input :personality_traits, as: :select, input_html: { multiple: true, class: :select_personality_trait }, collection: CoupleProfile::PERSONALITY_TRAITS
      f.input :activities, as: :select, input_html: { multiple: true, class: :select_activities }, collection: CoupleProfile::ACTIVITIES
      f.input :verified_profile
      f.has_many :images do |form|
        form.input :image, as: :file, hint: form.object.image.attached? ? image_tag(form.object.image.service_url, class: "admin_couple_img_small") : ""
      end
    end
    panel "Location", class: "panel location_panel" do
      f.inputs :location_attributes, for: [:location, f.object.location || Location.new] do |t|
        t.input :latitude
        t.input :longitude
      end
    end
    f.actions
  end
end
