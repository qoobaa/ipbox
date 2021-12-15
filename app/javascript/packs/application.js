import "../stylesheets/application";

import "bootstrap/dist/js/bootstrap";
import "@hotwired/turbo-rails";
import { Application } from "stimulus";
import { definitionsFromContext } from "stimulus/webpack-helpers";
import Rails from "@rails/ujs";
import jQuery from "jquery";

Rails.start();
window.Rails = Rails;
window.jQuery = jQuery;

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag "rails.png" %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context("../images", true)
// const imagePath = (name) => images(name, true)

import "controllers";
