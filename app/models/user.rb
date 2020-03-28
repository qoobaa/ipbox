class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  validates :company_name, presence: true
  validates :address, presence: true
  validates :postal_code, presence: true, format: {with: /\A[0-9]{2}-[0-9]{3}\z/}
  validates :city, presence: true
  validates :vatin, presence: true

  has_many :projects, dependent: :destroy
  has_many :entries, dependent: :destroy
  has_many :invoices, dependent: :destroy

  after_create :capture

  private

  def capture
    customer = Stripe::Customer.create(
      name: company_name,
      email: email,
      address: {
        city: city,
        country: "PL",
        line1: address,
        postal_code: postal_code
      }
    )
    self.stripe_customer_id = customer.id

    Stripe::PaymentIntent.update(stripe_payment_intent_id, customer: stripe_customer_id)
    Stripe::PaymentIntent.capture(stripe_payment_intent_id)
  end
end
