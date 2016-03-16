class ConcatenateNameColumnsOnUsers < ActiveRecord::Migration
  def up
    execute(concat_name_for_accounts)
  end

  def down
    execute(split_name_for_accounts)
  end

  private

  def concat_name_for_accounts
    %q(UPDATE users
       SET first_name = first_name || ' ' || last_name
       WHERE type = 'Users::Account';)
  end

  def split_name_for_accounts
    %q(UPDATE users
       SET first_name = split_part(first_name, ' ', 1),
           last_name  = split_part(first_name, ' ', 2)
       WHERE type = 'Users::Account';)
  end
end
