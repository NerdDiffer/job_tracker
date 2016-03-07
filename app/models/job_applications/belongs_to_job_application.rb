module JobApplications
  module BelongsToJobApplication
    def job_application_title
      job_application.title
    end

    def user
      job_application.user
    end
  end
end
