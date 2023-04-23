//יבוא אייקון של הלוגו
import { TbBusinessplan } from 'react-icons/tb'

import { Link } from 'react-router-dom'
import { connectWallet } from '../services/blockchain'
import { truncate, useGlobalState } from '../store'

//כותרת ראשית בדף הבית איפה שהלוגו 
const Header = () => {
  const [connectedAccount] = useGlobalState('connectedAccount')

  return (
    <header
      className="flex justify-between items-center
        p-5 bg-white shadow-lg fixed top-0 left-0 right-0"
    >
        {/* בעת לחיצה על הלוגו יועבר לדף הבית  */}
      <Link
        to="/"
        className="flex justify-start items-center
      text-xl text-black space-x-1"
      >
        <span>PickUs</span>
        <TbBusinessplan />
      </Link>

        {/* כפתור להתחברות לארנק */}
      <div className="flex space-x-2 justify-center">
        {/*  האם יש כבר ארנק שמחובר באתר */}
        {connectedAccount ? (
            //אם כן אז נציג על הכפתור את הכתובת של הארנק שמחובר
          <button
            type="button"
            className="inline-block px-6 py-2.5 bg-green-600
            text-white font-medium text-xs leading-tight uppercase
            rounded-full shadow-md hover:bg-green-700"
          >
             {/* הפונקציה טראנקאט מבצעת חיתוך כדי שהכתובת לא תופיע בצורה לא אסטטית */}
            {truncate(connectedAccount, 4, 4, 11)}
             
          </button>
        ) : (
            //אם לא, נציג כפתור שיהיה רשום עליו התחבר לארנק 
          <button
            type="button"
            className="inline-block px-6 py-2.5 bg-green-600
            text-white font-medium text-xs leading-tight uppercase
            rounded-full shadow-md hover:bg-green-700"
            //בעת לחיצה - התחברות לארנק
            onClick={connectWallet}
          >
            Connect Wallet
          </button>
        )}
      </div>
    </header>
  )
}

export default Header