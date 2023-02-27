class User < ApplicationRecord
  belongs_to :current_project, class_name: "Project", optional: true  

  # Keep track of ransack search parameters to reset after edit for example
  kredis_hash :index_settings
  kredis_hash :index_searches
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
