module Users
  module AuthenticatedSessions
    def remember
      update_attribute(:remember_digest, digest(new_token))
    end

    def forget
      update_attribute(:remember_digest, nil)
    end

    def authenticated?(attribute, token)
      attribute_digest = public_send("#{attribute}_digest")
      return false if attribute_digest.nil?
      match?(attribute_digest, token)
    end

    private

    def cost
      if ActiveModel::SecurePassword.min_cost
        BCrypt::Engine::MIN_COST
      else
        BCrypt::Engine.cost
      end
    end

    def digest(remember_token)
      BCrypt::Password.create(remember_token, cost: cost)
    end

    def new_token
      SecureRandom.urlsafe_base64
    end

    def match?(digest, token)
      password_digest = BCrypt::Password.new(digest)
      password_digest == token
    end
  end
end
