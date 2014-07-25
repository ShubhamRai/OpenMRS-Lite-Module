/**
 * The contents of this file are subject to the OpenMRS Public License
 * Version 1.0 (the "License"); you may not use this file except in
 * compliance with the License. You may obtain a copy of the License at
 * http://license.openmrs.org
 *
 * Software distributed under the License is distributed on an "AS IS"
 * basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
 * License for the specific language governing rights and limitations
 * under the License.
 *
 * Copyright (C) OpenMRS, LLC.  All Rights Reserved.
 */
package org.openmrs.module.OpenmrsLite.fragment.controller.patientdashboard;

import org.junit.Before;
import org.junit.Test;
import org.openmrs.Patient;
import org.openmrs.module.appframework.feature.FeatureToggleProperties;
import org.openmrs.module.emrapi.patient.PatientDomainWrapper;
import org.openmrs.ui.framework.fragment.FragmentConfiguration;

import static org.hamcrest.Matchers.instanceOf;
import static org.hamcrest.core.Is.is;
import static org.junit.Assert.assertThat;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

public class ContactInfoFragmentControllerTest {

	ContactInfoFragmentController controller;

	FragmentConfiguration config;

	FeatureToggleProperties toggle;

	PatientDomainWrapper wrapper;

	@Before
	public void before() {
		controller = new ContactInfoFragmentController();
		config = new FragmentConfiguration();
		toggle = mock(FeatureToggleProperties.class);
		wrapper = mock(PatientDomainWrapper.class);
	}

	@Test
	public void shouldReturnPatientAndHideEditInfoContactButtonAttributes() {
		//given
		Patient patient = new Patient();
		config.addAttribute("patient", patient);

		//when
		when(toggle.isFeatureEnabled("hideEditPatientContactInfoButton")).thenReturn(true);
		controller.controller(config, wrapper, toggle);

		//then
		assertThat((Boolean) config.get("hideEditContactInfoButton"), is(true));
		assertThat(config.get("patient"), is(instanceOf(PatientDomainWrapper.class)));
	}
}
