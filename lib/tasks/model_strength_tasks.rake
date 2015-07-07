namespace :model_strength do
  desc 'Compute score for all entries in database of a given model'
  task :compute_scores, [:model] => [:environment] do |t, args|
    model = args.model.singularize.classify.constantize
    model.find_each do |model_item|
      model_item.save!
    end
  end
end
