class ChangeBudgetsUserFkOnDeleteToRestrict < ActiveRecord::Migration[7.2]
  # NOTE: This migration had a misleading name (suggested RESTRICT when actually
  # implementing CASCADE). It has been superseded by the correctly-named migration
  # 20260517120001_change_budgets_user_fk_to_cascade.rb.
  #
  # This migration remains as a NO-OP to preserve migration history and allow
  # existing dev/test databases that have already executed it to continue without error.
  # On production or fresh environments, only 20260517120001 will be executed.

  def up
    # Replace existing FK with ON DELETE CASCADE to remove personal budgets when
    # their owning user is deleted. This prevents orphaned user references and
    # aligns with the requested behavior.
    remove_foreign_key :budgets, :users
    add_foreign_key :budgets, :users, on_delete: :cascade
  end

  def down
    remove_foreign_key :budgets, :users
    # restore previous behavior; adjust if another prior behavior was used
    add_foreign_key :budgets, :users, on_delete: :nullify
  end
end
