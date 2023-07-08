using System.Collections;
using System.Collections.Generic;
using UnityEngine;


namespace Oculus.Interaction.Samples
{
    public class GetMesh : MonoBehaviour
    {
        public Renderer rd;

        // OnTriggerEnter is called when the Collider other enters the trigger
        private void OnTriggerEnter(Collider other)
        {
            if (other.CompareTag("block"))
            {
                rd = other.transform.GetChild(0).GetChild(0).GetComponent<Renderer>();
                Debug.Log("GetMesh");
            }
        }

        // OnTriggerExit is called when the Collider other has stopped touching the trigger
        private void OnTriggerExit(Collider other)
        {
            rd = null;
            Debug.Log("MeshClear");
        }
    }
}


