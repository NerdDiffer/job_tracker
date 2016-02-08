class JobApplicationsController < ApplicationController
  include SortingHelper

  helper_method :sort_column, :sort_direction

  before_action :logged_in_user
  before_action :set_job_application, only: [:show, :edit, :update, :destroy]

  # GET /job_applications
  # GET /job_applications.json
  def index
    active = params.slice(:active)
    @job_applications = JobApplication.filter(active).sorted
    @job_applications = custom_index_sort if params[:sort]
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
    @job_application = JobApplication.new(job_application_params_with_company_id)

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
      if @job_application.update(job_application_params_with_company_id)
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

  def set_job_application
    @job_application = JobApplication.find(params[:id])
  end

  def whitelisted_attr
    [:company_id, :active, :sort, :direction, :title, :company_name]
  end

  def job_application_params
    params.require(:job_application).permit(whitelisted_attr)
  end

  def job_application_params_with_company_id
    job_application_params.merge(company_id: set_company_id)
  end

  def set_company_id
    company_name = params[:job_application][:company_name]
    Company.get_record_val_by(:name, company_name)
  end

  def model
    JobApplication
  end

  def collection
    @job_applications
  end

  def column_to_sort_by
    'updated_at'
  end
end
