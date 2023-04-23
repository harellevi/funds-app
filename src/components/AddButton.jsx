//הכפתור הירוק שזז עם המסך - דרכו ניתן לפתוח טופס יצירת פרויקט בצורה מהירה
//נייבא את הטופס ע"י גלובל סטייט לכן נייבא אותו
import { setGlobalState } from '../store'
//נייבא אייקון של פלוס
import { BsPlusLg } from 'react-icons/bs'

const AddButton = () => {
  return (
    <div className="fixed right-10 bottom-10 flex space-x-2 justify-center">
      <button
        type="button"
        className="flex justify-center items-center w-9 h-9 bg-green-600
        text-white font-medium text-xs leading-tight uppercase
        rounded-full shadow-md hover:bg-green-700"
        //בעת לחיצה הגודל של הטופס יהפוך ל100 והטופס יופיע
        onClick={() => setGlobalState('createModal', 'scale-100')}
      >
        {/*שימוש באייקון פלוס */}
        <BsPlusLg className='font-bold' size={20} />
      </button>
    </div>
  )
}

export default AddButton