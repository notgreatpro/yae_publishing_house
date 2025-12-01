# app/models/admin_user.rb
class AdminUser < ApplicationRecord
  devise :database_authenticatable, 
         :recoverable, :rememberable, :trackable,
         authentication_keys: [:username]  
  
  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }, if: :password_required?
  
  # Add this method for Ransack
  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "current_sign_in_at", "current_sign_in_ip", "email", 
     "id", "last_sign_in_at", "last_sign_in_ip", "remember_created_at", 
     "reset_password_sent_at", "reset_password_token", "sign_in_count", 
     "updated_at", "username"]
  end
  
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if (login = conditions.delete(:email))
      where(conditions.to_h).where(["username = :value", { value: login }]).first
    elsif conditions.has_key?(:username)
      where(conditions.to_h).first
    end
  end
  
  def email_required?
    false
  end
  
  def email_changed?
    false
  end
  
  private
  
  def password_required?
    new_record? || password.present? || password_confirmation.present?
  end
end