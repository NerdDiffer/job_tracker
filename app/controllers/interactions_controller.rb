class InteractionsController < ApplicationController
  include SortingHelper

  helper_method :sort_column, :sort_direction

  before_action :logged_in_user
  before_action :set_interaction, only: [:show, :edit, :update, :destroy]

  # GET /interactions
  # GET /interactions.json
  def index
    @interactions = Interaction.sorted
    @interactions = custom_index_sort if params[:sort]
  end

  # GET /interactions/1
  # GET /interactions/1.json
  def show
  end

  # GET /interactions/new
  def new
    contact_id = params[:contact_id]
    opts = { contact_id: contact_id, approx_date: Time.now }
    @interaction = Interaction.new(opts)
  end

  # GET /interactions/1/edit
  def edit
  end

  # POST /interactions
  # POST /interactions.json
  def create
    @interaction = Interaction.new(interaction_params_with_contact_id)

    respond_to do |format|
      if @interaction.save
        format.html { redirect_to @interaction, notice: 'Interaction was successfully created.' }
        format.json { render :show, status: :created, location: @interaction }
      else
        format.html { render :new }
        format.json { render json: @interaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /interactions/1
  # PATCH/PUT /interactions/1.json
  def update
    respond_to do |format|
      if @interaction.update(interaction_params_with_contact_id)
        format.html { redirect_to @interaction, notice: 'Interaction was successfully updated.' }
        format.json { render :show, status: :ok, location: @interaction }
      else
        format.html { render :edit }
        format.json { render json: @interaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /interactions/1
  # DELETE /interactions/1.json
  def destroy
    @interaction.destroy
    respond_to do |format|
      format.html { redirect_to interactions_url, notice: 'Interaction was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_interaction
    id = params[:id]
    @interaction = Interaction.find(id)
  end

  def whitelisted_attr
    [:contact_id, :notes, :approx_date, :medium, :contact_name]
  end

  def interaction_params
    params.require(:interaction).permit(whitelisted_attr)
  end

  def interaction_params_with_contact_id
    interaction_params.merge(contact_id: set_contact_id)
  end

  def set_contact_id
    contact_name = params[:interaction][:contact_name]
    Contact.get_record_val_by(:name, contact_name)
  end

  def model
    Interaction
  end

  def collection
    @interactions
  end

  def column_to_sort_by
    'approx_date'
  end
end
