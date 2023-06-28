document.addEventListener('turbo:load', function() {
  if (window.location.pathname === '/converter') {
    let featureElement = document.getElementById('feature_id');
    if (featureElement != null) {
      featureElement.addEventListener('change', function() {
        const selectedFeatureId = this.value;
        const form = document.getElementById('csv_convert_form');
        form.action = `/features/${selectedFeatureId}/convert`;
      });
    }
  }
});
