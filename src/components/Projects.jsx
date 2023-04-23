//החלק של כל הפרוקיטים בדף הבית

import Identicons from 'react-identicons'
import { useState, useEffect } from 'react'
import { Link } from 'react-router-dom'
import { truncate, daysRemaining } from '../store'
import { FaEthereum } from 'react-icons/fa'

const Projects = ({ projects }) => {
  const [end, setEnd] = useState(4)
  const [count] = useState(4)
  const [collection, setCollection] = useState([])

  //פונקציה שמחזירה את הפרויקטים שקיבלנו מהתחלה עד למשתנה סוף
  const getCollection = () => projects.slice(0, end)

  //כל פעם שיהיה שינוי בפרויקטים או במשתנה סוף -נטען מחדש את הפרויקטים שבטווח
  useEffect(() => {
    setCollection(getCollection())
  }, [projects, end])

  return (
    <div className="flex flex-col px-6 mb-7">
         {/* הצגה של כל הפרויקטים בתור מאפינג כאשר האינדקס הוא איי והערך הוא הפרויקט עם כל תכונותיו */}
      <div className="flex justify-center items-center flex-wrap">
        {collection.map((project, i) => (
          <ProjectCard key={i} project={project} />
        ))}
      </div>

        {/* כפתור לטעינת עוד פרויקטים */}
        {/* //תחילה נוודא שיש עוד פרויקטים להציג */}
      {projects.length > collection.length ? (
        //אם כן נציגת את הכפתור
        <div className="flex justify-center items-center my-5">
          <button
            type="button"
            className="inline-block px-6 py-2.5 bg-green-600
          text-white font-medium text-xs leading-tight uppercase
          rounded-full shadow-md hover:bg-green-700"
          //ברגע שילחצו על הכפתור- המשתנה סוף (מלמעלה)  יהפוך לגדול יותר ויוצגו יותר פרויקטים
            onClick={() => setEnd(end + count)}
          >
            Load more
          </button>
        </div>
        //אם אין עוד פרויקטים להציג הכפתור יעלם  
      ) : null}
    </div>
  )
}

const ProjectCard = ({ project }) => {
  const expired = new Date().getTime() > Number(project?.expiresAt + '000')

  return (
    <div id="projects" className="rounded-lg shadow-lg bg-white w-64 m-4">
        {/* עבור כל פרויקט לחיצה עליו תוביל לדף הייחודי שלו */}
      <Link to={'/projects/' + project.id}>
        {/* תמונה של הפרויקט */}
        <img
          src={project.imageURL}
          alt={project.title}
          className="rounded-xl h-64 w-full object-cover"
        />
        {/* כותרת הפרויקט */}
        <div className="p-4">
          <h5>{truncate(project.title, 25, 0, 28)}</h5>

          <div className="flex flex-col">
            <div className="flex justify-start space-x-2 items-center mb-3">
              <Identicons
                className="rounded-full shadow-md"
                string={project.owner}
                size={15}
              />
              <small className="text-gray-700">
                {truncate(project.owner, 4, 4, 11)}
              </small>
            </div>
                {/* הצגת התוקף של הפרויקט */}
            <small className="text-gray-500">
              {expired ? 'Expired' : daysRemaining(project.expiresAt) + ' left'}
            </small>
          </div>
            {/* הצגת הקו הירוק שמראה כמה כסף נאסף  */}
          <div className="w-full bg-gray-300 overflow-hidden">
            <div
              className="bg-green-600 text-xs font-medium
            text-green-100 text-center p-0.5 leading-none
            rounded-l-full"
            //חישוב אחוז הכסף שנאסף עד כה 
              style={{ width: `${(project.raised / project.cost) * 100}%` }}
            ></div>
          </div>

          <div
            className="flex justify-between items-center 
        font-bold mt-1 mb-2 text-gray-700"
          >
            {/* כמות הכסף שנאסף */}
            <small>{project.raised} ETH Raised</small>
            <small className="flex justify-start items-center">
              <FaEthereum />
              {/* כמות הכסף שנדרשת */}
              <span>{project.cost} ETH</span>
            </small>
          </div>

          <div
            className="flex justify-between items-center flex-wrap
            mt-4 mb-2 text-gray-500 font-bold"
          >
            <small>
              {project.backers} Backer{project.backers == 1 ? '' : 's'}
            </small>
            {/* הצגת הסטטוס של הפרויקט כתלות בערך של המשתנה אקספיירד */}
            <div>
              {expired ? (
                <small className="text-red-500">Expired</small>
              ) : project?.status == 0 ? (
                <small className="text-gray-500">Open</small>
              ) : project?.status == 1 ? (
                <small className="text-green-500">Accepted</small>
              ) : project?.status == 2 ? (
                <small className="text-gray-500">Reverted</small>
              ) : project?.status == 3 ? (
                <small className="text-red-500">Deleted</small>
              ) : (
                <small className="text-orange-500">Paid</small>
              )}
            </div>
          </div>
        </div>
      </Link>
    </div>
  )
}

export default Projects