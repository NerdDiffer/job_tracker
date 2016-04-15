module JobApplications
  class PostingsController < ApplicationController
    include SortingHelper
    include ScaffoldedActions
    include OwnResources

    attr_reader :posting

    helper_method :sort_column, :sort_direction

    before_action :logged_in_user
    before_action :set_posting, only: [:show, :edit, :update, :destroy]
    before_action :check_user,  only: [:show, :edit, :update, :destroy]

    def index
      @postings = collection_belonging_to_user
      @postings = @postings.sorted
      @postings = custom_index_sort if params[:sort]
    end

    def show
    end

    def new
      opts = {
        job_application_id: params[:job_application_id],
        posting_date: Time.now.utc
      }
      @posting = Posting.new(opts)
    end

    def edit
    end

    def create
      @posting = Posting.new(posting_params_with_associated_ids)

      respond_to do |format|
        if posting.save
          successful_creation(format, posting.job_application)
        else
          failed_creation(format, posting)
        end
      end
    end

    def update
      respond_to do |format|
        if posting.update(posting_params)
          successful_update(format, posting.job_application)
        else
          failed_update(format, posting)
        end
      end
    end

    def destroy
      @posting.destroy
      respond_to do |format|
        destruction(format, posting.job_application)
      end
    end

    private

    def set_posting
      id = params[:job_application_id]
      @posting = Posting.find_by_job_application_id(id)
    end

    def whitelisted_attr
      [:job_application_id, :posting_date, :source_id, :job_title, :content,
       :job_application_title]
    end

    def posting_params
      params.require(:job_applications_posting).permit(whitelisted_attr)
    end

    def posting_params_with_associated_ids
      job_application_id = params[:job_application_id]
      posting_params.merge(job_application_id: job_application_id)
    end

    def model
      Posting
    end

    def collection
      @postings
    end

    def member
      @posting
    end

    def default_sorting_column
      'posting_date'
    end
  end
end
