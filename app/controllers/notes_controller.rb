class NotesController < ApplicationController
  # TODO: is this needed anymore?
  include SortingHelper
  include ScaffoldedActions

  helper_method :sort_column, :sort_direction

  before_action :logged_in_user
  before_action :load_notable
  before_action :set_note, only: [:show, :edit, :update, :destroy]

  # GET /notes
  # GET /notes.json
  def index
    # TODO: Is this action needed anymore?
    @notes = @notable.notes.sorted
    @notes = custom_index_sort if params[:sort]
  end

  # GET /notes/1
  # GET /notes/1.json
  def show
  end

  # GET /notes/new
  def new
    @note = @notable.notes.new
  end

  # GET /notes/1/edit
  def edit
  end

  # POST /notes
  # POST /notes.json
  def create
    @note = build_note

    respond_to do |format|
      if @note.save
        message = "Note created for #{@notable.class}"
        format.html { redirect_to @notable, notice: message }
        format.json { render :show, status: :created, location: @notable }
      else
        format.html { render :new }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /notes/1
  # PATCH/PUT /notes/1.json
  def update
    respond_to do |format|
      if @note.update(note_params)
        message = "Successfully updated Note for #{@notable.class}"
        format.html { redirect_to @notable, notice: message }
        format.json { render :show, status: :ok, location: @notable }
      else
        format.html { render :edit }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /notes/1
  # DELETE /notes/1.json
  def destroy
    @note.destroy
    respond_to do |format|
      destruction(format, @notable)
    end
  end

  private

  def set_note
    id = params[:id]
    @note = Note.find(id)
  end

  def build_note
    contents = params[:note][:contents]
    user_id = current_user.id
    build_opts = { contents: contents, user_id: user_id }
    @notable.notes.build(build_opts)
  end

  def whitelisted_attr
    [:contents]
  end

  def note_params
    params.require(:note).permit(whitelisted_attr)
  end

  # based off Railscast #154
  def load_notable
    resource = request_path[1]
    id = request_path[2]
    model = inflect(resource)
    @notable = model.find(id)
  end

  def request_path
    request.path.split('/')
  end

  def inflect(resource)
    resource.singularize.classify.constantize
  end

  # based off Railscast #154
  # def load_notable_alternate
  #   model = [Contact, JobApplication].detect do |m|
  #     model_id = "#{m.name.underscore}_id"
  #     params[model_id]
  #   end

  #   model_param = "#{model.name.underscore}_id"
  #   model_id = params[model_param]
  #   @notable = model.find(model_id)
  # end

  def model
    Note
  end

  def collection
    @notes
  end

  def default_sorting_column
    'updated_at'
  end
end
