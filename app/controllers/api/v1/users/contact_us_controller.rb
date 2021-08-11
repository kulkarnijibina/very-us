# frozen_string_literal: true

module Api
  module V1
    module Users
      class ContactUsController < ApiController
        def create
          contact_us = Contact.create(contact_detail_params)
          render_message('Your request is not registered', 400) unless contact_us.save
          render_success_response({
                                    contact_us: single_serializer.new(contact_us, serializer: Api::V1::Users::ContactUsSerializer)
                                  }, 'Your request is registered', 201)
        end

        def update
          contact_us = Contact.find(params[:id])
          render_message('Contact detail is not found', 404) unless contact_us.present?
          return render_message('Contact detail is not update', 401) unless contact_us.update(contact_detail_params)

          render_success_response({
                                    contact_us: single_serializer.new(contact_us, serializer: Api::V1::Users::ContactUsSerializer)
                                  }, 'Your request updated sucessfully', 200)
        end

        private

        def contact_detail_params
          params.require(:contact).permit(:name, :email, :message)
        end
      end
    end
  end
end
