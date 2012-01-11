class BushidoUserHooks < Bushido::EventObserver
  def user_added
    user.create(:email  => params['data']['email'],
      :ido_id => params['data']['ido_id'],
      :active => true)
  end

  def user_removed
    User.find_by_ido_id(params['data']['ido_id']).try(:disable!)
  end

  def user_updated
    data = params['data']
    user = User.find_by_ido_id(data['ido_id'])
    if user
      user.update_attributes({
          :email      => data['email'],
          :first_name => data['first_name'],
          :last_name  => data['last_name'],
          :locale     => data['locale'],
          :timezone   => data['timezone']
        })
    end
  end
end
