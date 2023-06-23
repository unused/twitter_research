# frozen_string_literal: true

# The training samples to test the classifier have been take from the following
# blog post:
# https://medium.com/analytics-vidhya/use-naive-bayes-algorithm-for-categorical-and-numerical-data-classification-935d90ab273f
describe TwitterResearch::Bayes do
  subject(:classifier) { described_class.new }

  it 'can handle a hash of words' do
    classifier.train(:stub, description: { "zero" => 2, "two" => 2 })
    classifier.train(:test, description: { "one" => 1, "two" => 2, "three" => 3 })
    labels = classifier.evaluate(description: { "one" => 2, "two" => 1 })
    expect(labels).to eq(stub: 0.125, test: 0.25)
  end

  context "with trained samples" do
    def test_samples
      [
        { city: "dallas",   gender: "male",   income: 40_367,  illness: "no" },
        { city: "dallas",   gender: "female", income: 41_524,  illness: "yes" },
        { city: "dallas",   gender: "male",   income: 46_373,  illness: "yes" },
        { city: "new york", gender: "male",   income: 98_096,  illness: "no" },
        { city: "new york", gender: "female", income: 102_089, illness: "no" },
        { city: "new york", gender: "female", income: 100_662, illness: "no" },
        { city: "new york", gender: "male",   income: 117_263, illness: "yes" },
        { city: "dallas", gender: "male", income: 56_645, illness: "no" }
      ]
    end

    before do
      test_samples.each do |row|
        classifier.train row[:illness], row.except(:illness)
      end
    end

    it "has labels" do
      expect(classifier.labels).to eq %w[no yes]
    end

    it "calculates probablities of city attributes" do
      city_probs = {
        "no" => { "dallas" => 2/4r, "new york" => 3/4r },
        "yes" => { "dallas" => 2/4r, "new york" => 1/4r }
      }
      result = classifier.prob(:city).transform_values(&:to_h)
      expect(result).to eq city_probs
    end

    it "calculates probablities of gender attribute" do
      gender_probs = {
        "no" => { "male" => 3/5r, "female" => 2/3r },
        "yes" => { "male" => 2/5r, "female" => 1/3r }
      }
      result = classifier.prob(:gender).transform_values(&:to_h)
      expect(result).to eq gender_probs
    end

    it "calculates probablities by category: city no dallas" do
      expect(classifier.prob(:city)["no"]["dallas"]).to eq 2/4r
    end

    it "calculates probablities by category: gender no female" do
      expect(classifier.prob(:gender)["no"]["female"]).to eq 2/3r
    end

    it "calculates probablities by category: city yes dallas" do
      expect(classifier.prob(:city)["yes"]["dallas"]).to eq 2/4r
    end

    it "calculates probablities by category: gender yes female" do
      expect(classifier.prob(:gender)["yes"]["female"]).to eq 1/3r
    end

    it "specifies numerical probabilities: income no" do
      result = classifier.evaluate(income: 100_000)
      expect(result["no"]).to be_within(0.000001).of 0.0000107421
    end

    it "specifies numerical probabilities: income yes" do
      result = classifier.evaluate(income: 100_000)
      expect(result["yes"]).to be_within(0.0000001).of 0.0000071278
    end

    it "evaluates categorical classes" do
      result = { "no" => 1/3r, "yes" => 1/6r }
      expect(classifier.evaluate(gender: "female", city: "dallas")).to eq result
    end
  end
end
