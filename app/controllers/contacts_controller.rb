class ContactsController < ApplicationController

  helper_method :sort_column

  before_action :logged_in_user
  before_action :set_contact, only: [:show, :edit, :update, :destroy]

  # GET /contacts
  # GET /contacts.json
  def index
    @contacts = Contact.all
    if params[:sort]
      @contacts = Contact.sort_by_attribute(@contacts,
                                            params[:sort],
                                            params[:direction])
    end
  end

  # GET /contacts/1
  # GET /contacts/1.json
  def show
  end

  # GET /contacts/new
  def new
    opts = { company_id: params[:company_id] }
    @contact = Contact.new(opts)
  end

  # GET /contacts/1/edit
  def edit
  end

  # POST /contacts
  # POST /contacts.json
  def create
    @contact = Contact.new(contact_params)

    respond_to do |format|
      if @contact.save
        format.html { redirect_to @contact, notice: 'Contact was successfully created.' }
        format.json { render :show, status: :created, location: @contact }
      else
        format.html { render :new }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contacts/1
  # PATCH/PUT /contacts/1.json
  def update
    respond_to do |format|
      if @contact.update(contact_params)
        format.html { redirect_to @contact, notice: 'Contact was successfully updated.' }
        format.json { render :show, status: :ok, location: @contact }
      else
        format.html { render :edit }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contacts/1
  # DELETE /contacts/1.json
  def destroy
    @contact.destroy
    respond_to do |format|
      format.html { redirect_to contacts_url, notice: 'Contact was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_contact
      @contact = Contact.find(params[:id])
    end

    def whitelisted_attr
      [:first_name, :last_name, :title, :email, :company_id,
       :phone_office, :phone_mobile, :sort, :direction, :name, :company_name]
    end

    def contact_params
      params.require(:contact).permit(whitelisted_attr)
    end

    def sort_column
      sort_to_sym = params[:sort].to_sym unless params[:sort].nil?
      whitelisted_attr.include?(sort_to_sym) ? params[:sort] : 'name'
    end
end
