import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ["form", "link", "input"];

  connect() {
    this.isEditing = false;
    this._sync();
  }

  edit() {
    this.isEditing = true;
    this._sync();
    this.inputTarget.focus();
  }

  cancel() {
    this.isEditing = false;
    this._sync();
  }

  _sync() {
    this.formTarget.classList.toggle("d-none", !this.isEditing);
    this.linkTarget.classList.toggle("d-none", this.isEditing);
  }
}
