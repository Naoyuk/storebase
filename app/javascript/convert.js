document.getElementById('feature_id').addEventListener('change', function() {
  const selectedFeatureId = this.value;
  const form = document.getElementById('csv_convert_form');
  form.action = `/features/${selectedFeatureId}/convert`;
});
