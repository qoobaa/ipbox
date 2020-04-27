import { Controller } from "stimulus";
import { loadStripe } from "@stripe/stripe-js";

export default class extends Controller {
  static targets = ["card", "paymentIntentId", "orderId", "cardError", "submit", "blik", "blikError", "email"];

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
      this.cardErrorTarget.textContent = event.error.message;
    } else {
      this.cardErrorTarget.textContent = '';
    }
  }

  async _onSubmit(event) {
    if (this.paymentIntentIdTarget.value || this.orderIdTarget.value) {
      return;
    }

    event.preventDefault();

    if (this.blikTarget.value) {
      try {
        this.submitTarget.disabled = true;
        this.blikErrorTarget.textContent = "";

        const token = document.querySelector("meta[name='csrf-token']").content;

        const response1 = await fetch("/payu", {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
            "X-CSRF-Token": token
          },
          body: JSON.stringify({
            email: this.emailTarget.value,
            code: this.blikTarget.value
          })
        });

        const json1 = await response1.json();

        if (json1.error) throw new Error(json1.error);

        let status = "PENDING";

        while (status === "PENDING") {
          await this.timeout(1000);
          let response2 = await fetch(`/payu/${json1.id}`);
          const json2 = await response2.json();

          if (json2.error) throw new Error(json2.error);

          status = json2.status;
        }

        this.orderIdTarget.value = json1.id;
        this.element.submit();
      } catch (error) {
        this.blikErrorTarget.textContent = error.message;
        this.submitTarget.disabled = false;
      }
    } else {
      this.submitTarget.disabled = true;
      this.stripe.confirmCardPayment(this.data.get("clientSecret"), { payment_method: { card: this.card } })
        .then((result) => {
          if (result.error) {
            this.cardErrorTarget.textContent = result.error.message;
            this.submitTarget.disabled = false;
          } else {
            this.paymentIntentIdTarget.value = result.paymentIntent.id;
            this.element.submit();
          }
        });
    }
  }

  timeout(ms) {
    return new Promise(resolve => window.setTimeout(resolve, ms));
  }
};
