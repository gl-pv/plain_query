# frozen_string_literal: true

RSpec.describe PlainQuery do
  describe 'valid query object' do
    let!(:unmoderated_post) do
      Post.create(title: 'name_for_search', content: 'post_1', moderated: false, count_of_views: 1,
                  reading_duration: 10)
    end

    let!(:viewed_moderated_post) do
      Post.create(title: 'post_3', content: 'post_3', moderated: true, count_of_views: 5,
                  reading_duration: 3)
    end

    let!(:unviewed_moderated_post) do
      Post.create(title: 'name_for_search', content: 'post_2', moderated: true, count_of_views: 0,
                  reading_duration: 24)
    end

    context 'without inheritance' do
      subject { PostsQuery.call(Post.all, options) }

      context 'without options' do
        let(:options) { {} }
        let(:correct_scope) { [viewed_moderated_post, unviewed_moderated_post] }

        it { is_expected.to eq(correct_scope) }
      end

      context 'with options' do
        let(:options) { { title: 'name_for_search', with_unmoderated: true } }
        let(:correct_scope) { [unmoderated_post, unviewed_moderated_post] }

        it { is_expected.to eq(correct_scope) }
      end
    end

    context 'with inheritance' do
      subject { LongReadPostsQuery.call(Post.all, options) }

      context 'with small reading duration filter value' do
        let(:options) { { reading_duration_gt: 1 } }

        let(:correct_scope) { [viewed_moderated_post, unmoderated_post, unviewed_moderated_post] }

        it { is_expected.to eq(correct_scope) }
      end

      context 'with big reading duration filter value' do
        let(:options) { { reading_duration_gt: 7 } }

        let(:correct_scope) { [unmoderated_post, unviewed_moderated_post] }

        it { is_expected.to eq(correct_scope) }
      end
    end
  end
end
