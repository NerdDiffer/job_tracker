class NotesController < ApplicationController
  include SortingHelper
  include ScaffoldedActions
  include OwnResources

  attr_reader :note
  decorates_assigned :note

  helper_method :sort_column, :sort_direction

  before_action :logged_in_user
  before_action :load_notable,  except: :index
  before_action :set_note,      only: [:show, :edit, :update, :destroy]
  before_action :check_user,    only: [:show, :edit, :update, :destroy]

  def index
    @notes = collection_belonging_to_user
    @notes = custom_index_sort if params[:sort]
  end

  def show
  end

  def new
    @note = build_note
  end

  def edit
  end

  def create
    @note = build_note

    respond_to do |format|
      if note.save
        message = "Note created for #{@notable.class}"
        successful_creation(format, @notable, message)
      else
        failed_creation(format, note)
      end
    end
  end

  def update
    respond_to do |format|
      if note.update(note_params)
        message = "Successfully updated Note for #{@notable.class}"
        successful_update(format, @notable, message)
      else
        failed_update(format, note)
      end
    end
  end

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
    content = params[:note][:content] if params.key?(:note)
    user_id = current_user.id
    build_opts = { content: content, user_id: user_id }
    @notable.notes.build(build_opts)
  end

  def whitelisted_attr
    [:content]
  end

  def note_params
    params.require(:note).permit(whitelisted_attr)
  end

  def load_notable
    path_of_request = request_path
    resource = path_of_request[1]
    id = path_of_request[2]

    model = inflect(resource)
    @notable = model.find(id)
  end

  def request_path
    request.path.split('/')
  end

  def inflect(resource)
    resource.singularize.classify.constantize
  end

  def model
    Note
  end

  def collection
    @notes
  end

  def member
    @note
  end

  def default_sorting_column
    'updated_at'
  end
end
