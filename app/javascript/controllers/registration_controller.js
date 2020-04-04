import { Controller } from "stimulus";
import { loadStripe } from "@stripe/stripe-js";

export default class extends Controller {
  static targets = ["card", "paymentIntentId", "error", "submit"];

  async connect() {
    this.element.addEventListener("submit", this._onSubmit.bind(this));

    this.stripe = await loadStripe(this.data.get("stripePublishableKey"), { locale: "pl" });
    this.elements = this.stripe.elements();
    this.card = this.elements.create("card", {
      style: {
        base: {
          fontFamily: "Open Sans",
          fontWeight: 300,
          fontSize: "17px"
        }
      },
      hidePostalCode: true
    });

    this.card.mount(this.cardTarget);
    this.card.addEventListener('change', this._onCardChange.bind(this));
  }

  _onCardChange(event) {
    if (event.error) {
      this.errorTarget.textContent = event.error.message;
    } else {
      this.errorTarget.textContent = '';
    }
  }

  _onSubmit(event) {
    if (!this.paymentIntentIdTarget.value) {
      event.preventDefault();

      this.stripe.confirmCardPayment(this.data.get("clientSecret"), { payment_method: { card: this.card } })
        .then((result) => {
          if (result.error) {
            this.errorTarget.textContent = result.error.message;
            this.submitTarget.disabled = false;
          } else {
            this.paymentIntentIdTarget.value = result.paymentIntent.id;
            this.element.submit();
          }
        });
    }
  }
};
