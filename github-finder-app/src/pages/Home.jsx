import Navbar from '../components/layout/Navbar';
import { Link } from 'react-router-dom';
import UserResults from '../components/users/UserResults';

function Home() {

    return (
        <>
            <Navbar />

            <div className='flex-1 px-2 mx-2'>
                <div className='flex justify-end'>
                    <Link to='/about' className='btn btn-ghost btn-sm rounded-btn'>
                        About
                    </Link>
                </div>
            </div> 
            <UserResults />
        </>
     )
}

export default Home