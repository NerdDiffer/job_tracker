class JobApplicationsController < ApplicationController

  helper_method :sort_column

  before_action :logged_in_user
  before_action :set_job_application, only: [:show, :edit, :update, :destroy]

  # GET /job_applications
  # GET /job_applications.json
  def index
    @job_applications = JobApplication.filter(params.slice(:active)).sorted
    if params[:sort]
      @job_applications = JobApplication.sort_by_attribute(@job_applications,
                                                           params[:sort],
                                                           params[:direction])
    end
  end

  # GET /job_applications/1
  # GET /job_applications/1.json
  def show
  end

  # GET /job_applications/new
  def new
    opts = { company_id: params[:company_id] }
    @job_application = JobApplication.new(opts)
  end

  # GET /job_applications/1/edit
  def edit
  end

  # POST /job_applications
  # POST /job_applications.json
  def create
    ja_params = job_application_params.merge(company_id: set_company_id)
    @job_application = JobApplication.new(ja_params)

    respond_to do |format|
      if @job_application.save
        format.html { redirect_to @job_application, notice: 'Job application was successfully created.' }
        format.json { render :show, status: :created, location: @job_application }
      else
        format.html { render :new }
        format.json { render json: @job_application.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /job_applications/1
  # PATCH/PUT /job_applications/1.json
  def update
    respond_to do |format|

      ja_params = job_application_params.merge(company_id: set_company_id)
      if @job_application.update(ja_params)
        format.html { redirect_to @job_application, notice: 'Job application was successfully updated.' }
        format.json { render :show, status: :ok, location: @job_application }
      else
        format.html { render :edit }
        format.json { render json: @job_application.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /job_applications/1
  # DELETE /job_applications/1.json
  def destroy
    @job_application.destroy
    respond_to do |format|
      format.html { redirect_to job_applications_url, notice: 'Job application was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_job_application
      @job_application = JobApplication.find(params[:id])
    end

    def whitelisted_attr
      [:company_id, :active,
       :sort, :direction, :title,
       :company_name]
    end

    def job_application_params
      params.require(:job_application).permit(whitelisted_attr)
    end

    def sort_column
      # Make sure to call '#to_sym' on params, (if necessary) because
      # all keys in params hash are strings and you're comparing it against
      # the array from the #whitelisted_attr method.
      sort_to_sym = params[:sort].to_sym unless params[:sort].nil?
      whitelisted_attr.include?(sort_to_sym) ? params[:sort] : 'updated_at'
    end

    def set_company_id
      Company.get_record_val_by(:name,
                                params[:job_application][:company_name])
    end

end
