class Api::V1::RelationshipsController < ApiController

  before_action :load_relationship, only: [:destroy]

  def index
    related_users = CoupleProfile.where(id: current_user.couple_profile.relationships.where(action: params[:type]).pluck(:target_couple_id))
    render_success_response({ couples: related_users }, 'Related users')
  end

  def create
    action = params[:relationship][:action]
    target_couple_id = params[:relationship][:target_couple_id]

    need_to_burn_coins = need_to_burn_coins?(target_couple_id, action)
    response = BurnCoinsService.call(:per_save_for_later, current_user.couple_profile, need_to_burn_coins) do
      case action
      when "save_for_later"
        relationship = current_user.couple_profile.build_save_for_later_relationship(target_couple_id, action)
      when  "is_irrelevant_match"
        relationship = current_user.couple_profile.build_irrelevant_relationship(relationship_params)
      when  "is_reported"
        relationship = current_user.couple_profile.build_irrelevant_relationship(relationship_params)
      else
        relationship = current_user.couple_profile.relationships.build(relationship_params)
      end
      unless relationship.save
        raise relationship.errors.full_messages.first
      end
      relationship
    end

    if response[:success]
      render_success_response({ relationship: response[:data], balance: response[:balance], free_save_for_later_count: current_user.couple_profile.free_save_for_later_count }, success_message_for(action))
    else
      render_unprocessable_entity(response[:errors], {balance: response[:balance]})
    end
  end

  def destroy
    if @relationship.destroy
      render_success_response({}, "Couple unsaved successfully")
    else
      render_unprocessible_entity
    end
  end

  def unblock_couple
    current_user.couple_profile.relationships.where(target_couple_id: params[:relationship][:couple_id], action: "block").destroy_all
    render_success_response({}, "Couple Unblocked Successfully")
  end

  private

  def relationship_params
    params.require(:relationship).permit(:target_couple_id, :action,:reason)
  end

  def load_relationship
    @relationship = current_user.couple_profile.relationships.find_by(target_couple_id: params[:id], action: 'save_for_later')

    if @relationship.nil?
      render json: {
          message: "Relationship not found."
      }, status: :not_found
    end
  end

  def need_to_burn_coins?(target_couple_id, action)
    action == "save_for_later" && !current_user.couple_profile.can_use_free_save_for_later?(target_couple_id)
  end

  def success_message_for(action)
    case action
    when "save_for_later"
      "Couple is saved for later"
    when "block"
      "Couple Is Blocked"
    when "is_irrelevant_match"
      "Couple marked as irrelevant"
    when "is_reported"
      "Report flag raised sucessfully"
    else
      "Couple is #{action.humanize}"
    end
  end
end
