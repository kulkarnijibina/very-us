class Api::V1::MobileDevicesController < ApiController

  def create
    mobile_device = current_user.mobile_devices.new(mobile_device_params)
    if mobile_device.save
      current_user.mobile_devices.where.not(id: mobile_device).destroy_all
      render_success_response({
                              mobile_device: single_serializer.new(mobile_device, serializer: Api::V1::MobileDeviceSerializer)
                            })
    else
      render_unprocessable_entity('Device id not saved.')
    end
  end

  def delete_mobile_device
    mobile_devices = current_user.mobile_devices
    if mobile_devices && mobile_devices.destroy_all
      render_success_response({}, "Mobile Device successfully deleted")
    else
      render_unprocessable_entity('Error in deleting device id.')
    end
  end

  private

  def mobile_device_params
    params.require(:mobile_device).permit(:device_id)
  end

end
