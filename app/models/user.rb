# coding: utf-8
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  validates :company_name, presence: true
  validates :address, presence: true
  validates :postal_code, presence: true, format: {with: /\A[0-9]{2}-[0-9]{3}\z/}
  validates :city, presence: true
  validates :vatin, presence: true
  validates :tos_accepted, acceptance: true
  validates :einvoice_accepted, acceptance: true
  validate :payment_method, :payu_order_status

  has_many :projects, dependent: :destroy
  has_many :entries, dependent: :destroy
  has_many :invoices, dependent: :destroy

  after_create :stripe_capture, :payu_capture, :issue_invoice

  private

  def payu_order_status
    return if payu_order_id.blank? || BlikRetrieveJob.perform_now(payu_order_id) == "WAITING_FOR_CONFIRMATION"

    errors.add(:payment, "Płatność kodem Blik nie powiodła się")
  end

  def payu_capture
    return if payu_order_id.blank?

    BlikCaptureJob.perform_now(payu_order_id)
  end

  def stripe_capture
    return if stripe_payment_intent_id.blank?

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

  def payment_method
    return if stripe_payment_intent_id.present? || payu_order_id.present?

    errors.add(:payment, "Proszę wybrać sposób płatności")
  end

  def issue_invoice
    type = stripe_payment_intent_id ? "card" : "payu"
    IssueInvoiceJob.perform_later(self, type)
  end
end
