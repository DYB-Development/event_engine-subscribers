class RecordCowFed < EventEngine::Subscribers::Base
  subscribes_to :cow_fed

  def handle(event)
  end
end
