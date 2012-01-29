class BushidoUserHooks < Bushido::EventObserver
  def user_added
    # User might have been added before, so we'll find_or_create them
    # by their permanent_id (ido_id)
    user = User.find_or_create_by_ido_id(params['data']['ido_id'])

    user.update_attributes!(:email  => params['data']['email'],
                            :active => true)
  end

  def user_removed
    # Disable the user instead of destroying them, so all the data
    # associated with them stays (e.g. comments, projects, leads,
    # contacts, etc.)
    User.find_by_ido_id(params['data']['ido_id']).try(:disable!)
  end

  def user_updated
    data = params['data']
    user = User.find_by_ido_id(data['ido_id'])

    if user
      # Re-use the CAS login method to set all the extra attributes we
      # care about (first_name, last_name, email, local, timezone,
      # etc.)
      user.bushido_extra_attributes(data)
      user.save
    end
  end
end
