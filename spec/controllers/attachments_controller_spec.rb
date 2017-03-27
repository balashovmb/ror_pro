require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  describe 'DELETE #destroy' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:file) { create(:attachment, attachable: question) }
    let(:another_user) { create(:user) }

    context 'author of the question delete attachment' do
      it 'delete Attachment in database' do
        sign_in(user)
        expect { delete :destroy, params: { id: file }, format: :js }.to change(question.attachments, :count).by(-1)
      end
    end

    context 'authenticated user can not delete another users attachment' do
      it 'does not delete Attachment' do
        sign_in(another_user)
        expect { delete :destroy, params: { id: file }, format: :js }.not_to change(question.attachments, :count)
      end
    end
  end
end
