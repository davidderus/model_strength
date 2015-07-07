namespace :model_strength do
  desc 'Compute score for all entries in database of a given model'
  task :compute_scores, :model do
    # Task goes here
    p args.model
    p args.model.singularize.classify.constantize
  end
end
