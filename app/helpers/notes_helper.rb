module NotesHelper
  def generate_notable_link_dest(note)
    id   = note.notable_id
    type = note.notable_type.to_s

    if type == 'Contact'
      contact_path(id)
    elsif type == 'JobApplication'
      job_application_path(id)
    end
  end
end
