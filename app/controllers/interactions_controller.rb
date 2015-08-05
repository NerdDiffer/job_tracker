class InteractionsController < ApplicationController

  helper_method :sort_column

  before_action :logged_in_user
  before_action :set_interaction, only: [:show, :edit, :update, :destroy]

  # GET /interactions
  # GET /interactions.json
  def index
    @interactions = Interaction.sorted
    if params[:sort]
      @interactions = Interaction.sort_by_attribute(@interactions,
                                                    params[:sort],
                                                    params[:direction])
    end
  end

  # GET /interactions/1
  # GET /interactions/1.json
  def show
  end

  # GET /interactions/new
  def new
    opts = { contact_id: params[:contact_id] }
    @interaction = Interaction.new(opts)
  end

  # GET /interactions/1/edit
  def edit
  end

  # POST /interactions
  # POST /interactions.json
  def create
    @interaction = Interaction.new(interaction_params)

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
      if @interaction.update(interaction_params)
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
      @interaction = Interaction.find(params[:id])
    end

    def whitelisted_attr
      [:contact_id, :notes, :approx_date, :medium, :contact_name]
    end

    def interaction_params
      params.require(:interaction).permit(whitelisted_attr)
    end

    def sort_column
      sort_to_sym = params[:sort].to_sym unless params[:sort].nil?
      whitelisted_attr.include?(sort_to_sym) ? params[:sort] : 'approx_date'
    end
end
