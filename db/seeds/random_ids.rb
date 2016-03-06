module Seed
  class << self
    private

    def random_user_id
      @user_ids ||= User.all.map(&:id)
      @user_ids.sample
    end

    def random_company_id
      @company_ids ||= Company.all.map(&:id)
      @company_ids.sample
    end

    def random_source_id
      @source_ids ||= Source.all.map(&:id)
      @source_ids.sample
    end

    def random_contact_id(user_id = nil)
      if user_id.nil?
        @contact_ids ||= Contact.all.map(&:id)
        @contact_ids.sample
      else
        ids = Contact.belonging_to_user(user_id).map(&:id)
        ids.sample
      end
    end

    def random_job_application_id(user_id = nil)
      if user_id.nil?
        @job_application_ids ||= JobApplication.all.map(&:id)
        @job_application_ids.sample
      else
        ids = JobApplication.belonging_to_user(user_id).map(&:id)
        ids.sample
      end
    end

    def random_model
      [Contact, JobApplication].sample
    end

    def random_id(model, opts = {})
      model = model.to_s
      user_id = opts[:scope]

      case model
      when 'Contact'; then random_contact_id(user_id)
      when 'JobApplication'; random_job_application_id(user_id)
      else; fail 'pass in a valid model constant'
      end
    end
  end
end
