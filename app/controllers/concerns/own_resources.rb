module OwnResources
  private

  def check_user
    redirect_to(root_url) unless correct_user?
  end

  def correct_user?
    current_user?(member.user)
  end

  def collection_belonging_to_user
    model.belonging_to_user(current_user.id)
  end
end
