class PopulateUserIdColumnForNotes < ActiveRecord::Migration
  def up
    execute(move_data)
  end

  def down
    execute(reset_data)
  end

  private

  def move_data
    %q(UPDATE notes
       SET user_id = notable_id, notable_id = NULL, notable_type = NULL
       WHERE notable_type = 'User')
  end

  def reset_data
    %q(UPDATE notes
       SET user_id = NULL, notable_id = user_id, notable_type = 'User'
       WHERE user_id IS NOT NULL)
  end
end
