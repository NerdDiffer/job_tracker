module ScaffoldedActions
  private

  def save_and_respond(object)
    respond_to do |format|
      if object.save
        successful_creation(format, object)
      else
        failed_creation(format, object)
      end
    end
  end

  def successful_creation(format, object)
    message = "#{model} was successfully created."
    canned_success(format, object, message, :created)
  end

  def failed_creation(format, object)
    format.html { render :new }
    format.json { render json: object.errors, status: :unprocessable_entity }
  end

  def successful_update(format, object)
    message = "#{model} was successfully updated."
    canned_success(format, object, message, :ok)
  end

  def failed_update(format, object)
    format.html { render :edit }
    format.json { render json: object.errors, status: :unprocessable_entity }
  end

  def destruction(format, redirect_url)
    message = "#{model} was successfully destroyed."
    format.html { redirect_to redirect_url, notice: message }
    format.json { head :no_content }
  end

  def canned_success(format, object, message, status)
    format.html { redirect_to object, notice: message }
    format.json { render :show, status: status, location: object }
  end
end
