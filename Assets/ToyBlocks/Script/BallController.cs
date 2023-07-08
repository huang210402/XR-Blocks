using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Linq;

public class BallController : MonoBehaviour
{
    private Rigidbody rb;
    private Vector3 dir;
    private float mag;
    private float[] mags = new float[100];
    private float magave;

    // Start is called before the first frame update
    void Start()
    {
        rb = GetComponent<Rigidbody>();
    }

    // Update is called once per frame
    void FixedUpdate()
    {
        dir = rb.velocity.normalized;
        mag = rb.velocity.magnitude;
        mags[0] = mag;
        for (int i=99; i <= 1; i-- )
        {
            mags[i] = mags[i-1];
        }
        magave = mags.Average() * 100;
        if (magave <= 0.04f)
        {
            rb.AddForce(dir * 6.0f, ForceMode.Acceleration);
        }
        if(magave <= 0.005f)
        {
            rb.AddForce(dir * 50.0f, ForceMode.Acceleration);
        }
        //Debug.Log(magave);
    }

    private void OnCollisionEnter(Collision collision)
    {
        if(collision.gameObject.tag == "Finish")
        {
            this.enabled = false;
        }
    }
}
