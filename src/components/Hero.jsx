//דף הבית 

import { setGlobalState, useGlobalState } from '../store'

const Hero = () => {
    //נקבל את הסטטיסטיוקות
  const [stats] = useGlobalState('stats')

  return (
    <div className="text-center bg-white text-gray-800 py-24 px-6">
        {/* כותרת ראשית */}
      <h1
        className="text-5xl md:text-6xl xl:text-7xl font-bold
      tracking-tight mb-12"
      >
        <span className="capitalize">Bring creative projects to life on</span>
        <br />
        <span className="uppercase text-blue-600">PickUs.</span>
      </h1>
      <div className="flex justify-center items-center space-x-2">

        {/* כפתור ליצירת פרויקט */}
        <button
          type="button"
          className="inline-block px-6 py-2.5 bg-blue-600
        text-white font-medium text-xs leading-tight uppercase
        rounded-full shadow-md hover:bg-blue-700"
        //נגיד לכפתור שבעת לחיצה עליו יפתח הטופס (ע"י קריאיט מודל) והצורה שהוא יפתח היא למידה של 100 (בברירת מחדל הטופס הוא על 0 לא רואים אותו עד שלוחצים)
          onClick={() => setGlobalState('createModal', 'scale-100')}
        >
          Add Project
        </button>

        {/* כפתור לתמיכה בפרויקט */}
        <button
          type="button"
          className="inline-block px-6 py-2.5 border border-blue-600
        font-medium text-xs leading-tight uppercase text-blue-600
        rounded-full shadow-md bg-transparent hover:bg-blue-700
        hover:text-white"
        >
          Back Projects
        </button>
      </div>

        {/* טבלה עם סטטיסטיקות על כמות הפרויקטים, תומכים וכו' */}
      <div className="flex justify-center items-center mt-10">

        {/* כמות פרויקטים */}
        <div
          className="flex flex-col justify-center items-center
          h-20 border shadow-md w-full"
        >
          <span
            className="text-lg font-bold text-green-900
            leading-5"
          >
            {stats?.totalProjects || 0}
          </span>
          <span>Projects</span>
        </div>

        {/* כמות תומכים  */}
        <div
          className="flex flex-col justify-center items-center
          h-20 border shadow-md w-full"
        >
          <span
            className="text-lg font-bold text-green-900
            leading-5"
          >
            {stats?.totalBacking || 0}
          </span>
          <span>supporters</span>
        </div>

        {/* סה"כ תרומות שנאספו */}
        <div
          className="flex flex-col justify-center items-center
          h-20 border shadow-md w-full"
        >
          <span
            className="text-lg font-bold text-green-900
            leading-5"
          >
            {stats?.totalDonations || 0} ETH
          </span>
          <span>Donated</span>
        </div>
      </div>
    </div>
  )
}

export default Hero