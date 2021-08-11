class Api::V1::FaqsController < ApiController

  skip_before_action :authenticate_user!
  
	def index
    faqs = Faq.all
    unless faqs.empty?
      render_success_response({
                                faqs: array_serializer.new(faqs, serializer: Api::V1::FaqSerializer)
                              }, 'Faqs list', 200)
    else
      render_unprocessable_entity('There is no Faqs')
    end
	end

end
