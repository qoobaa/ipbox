import { Controller } from "stimulus";
import consumer from "../channels/consumer";

export default class extends Controller {
  static targets = ["awaiting", "complete", "entries"];

  connect() {
    consumer.subscriptions.create(
      { channel: "ImportsChannel", repository_id: this.data.get("repositoryId") },
      { received: this._received.bind(this) }
    );
  }

  _received(data) {
    const { entries } = data;

    this.awaitingTarget.classList.add("d-none");
    this.completeTarget.classList.remove("d-none");
    this.entriesTarget.innerHTML = entries;
  }
}
