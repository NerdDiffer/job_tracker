class PostingsController < ApplicationController
  include SortingHelper

  helper_method :sort_column, :sort_direction

  before_action :logged_in_user
  before_action :set_posting, only: [:show, :edit, :update, :destroy]

  # GET /postings
  # GET /postings.json
  def index
    @postings = Posting.sorted
    @postings = custom_index_sort if params[:sort]
  end

  # GET /postings/1
  # GET /postings/1.json
  def show
  end

  # GET /postings/new
  def new
    opts = {
      job_application_id: params[:job_application_id],
      posting_date: Time.now
    }
    @posting = Posting.new(opts)
  end

  # GET /postings/1/edit
  def edit
  end

  # POST /postings
  # POST /postings.json
  def create
    @posting = Posting.new(posting_params)

    respond_to do |format|
      if @posting.save
        format.html { redirect_to @posting, notice: 'Posting was successfully created.' }
        format.json { render :show, status: :created, location: @posting }
      else
        format.html { render :new }
        format.json { render json: @posting.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /postings/1
  # PATCH/PUT /postings/1.json
  def update
    respond_to do |format|
      if @posting.update(posting_params)
        format.html { redirect_to @posting, notice: 'Posting was successfully updated.' }
        format.json { render :show, status: :ok, location: @posting }
      else
        format.html { render :edit }
        format.json { render json: @posting.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /postings/1
  # DELETE /postings/1.json
  def destroy
    @posting.destroy
    respond_to do |format|
      format.html { redirect_to postings_url, notice: 'Posting was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_posting
    @posting = Posting.find(params[:id])
  end

  def whitelisted_attr
    [:job_application_id, :posting_date, :source, :job_title, :content,
     :job_application_title]
  end

  def posting_params
    params.require(:posting).permit(whitelisted_attr)
  end

  def model
    Posting
  end

  def collection
    @postings
  end

  def default_sorting_column
    'posting_date'
  end
end
