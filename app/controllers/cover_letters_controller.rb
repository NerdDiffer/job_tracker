class CoverLettersController < ApplicationController
  include SortingHelper

  helper_method :sort_column, :sort_direction

  before_action :logged_in_user
  before_action :set_cover_letter, only: [:show, :edit, :update, :destroy]

  # GET /cover_letters
  # GET /cover_letters.json
  def index
    @cover_letters = CoverLetter.sorted
    @cover_letters = custom_index_sort if params[:sort]
  end

  # GET /cover_letters/1
  # GET /cover_letters/1.json
  def show
  end

  # GET /cover_letters/new
  def new
    job_application_id = params[:job_application_id]

    opts = {
      job_application_id: job_application_id,
      sent_date: Time.now
    }

    @cover_letter = CoverLetter.new(opts)
  end

  # GET /cover_letters/1/edit
  def edit
  end

  # POST /cover_letters
  # POST /cover_letters.json
  def create
    @cover_letter = CoverLetter.new(cover_letter_params)

    respond_to do |format|
      if @cover_letter.save
        format.html { redirect_to @cover_letter, notice: 'Cover letter was successfully created.' }
        format.json { render :show, status: :created, location: @cover_letter }
      else
        format.html { render :new }
        format.json { render json: @cover_letter.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cover_letters/1
  # PATCH/PUT /cover_letters/1.json
  def update
    respond_to do |format|
      if @cover_letter.update(cover_letter_params)
        format.html { redirect_to @cover_letter, notice: 'Cover letter was successfully updated.' }
        format.json { render :show, status: :ok, location: @cover_letter }
      else
        format.html { render :edit }
        format.json { render json: @cover_letter.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cover_letters/1
  # DELETE /cover_letters/1.json
  def destroy
    @cover_letter.destroy
    respond_to do |format|
      format.html { redirect_to cover_letters_url, notice: 'Cover letter was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_cover_letter
    id = params[:id]
    @cover_letter = CoverLetter.find(id)
  end

  def whitelisted_attr
    [:job_application_id, :sent_date, :content, :job_application_title]
  end

  def cover_letter_params
    params.require(:cover_letter).permit(whitelisted_attr)
  end

  def model
    CoverLetter
  end

  def collection
    @cover_letters
  end

  def default_sorting_column
    'sent_date'
  end
end
